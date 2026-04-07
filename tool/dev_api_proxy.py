#!/usr/bin/env python3
"""
Dev-only HTTP proxy: forwards to the remote API and adds CORS headers so
Flutter Web (Chrome) can call it from http://localhost:<port>.

Remote Swagger: http://47.76.160.69/api/docs

Usage (Windows / macOS / Linux):
  python tool/dev_api_proxy.py

Then from frontend/:
  flutter run -d chrome --dart-define=API_BASE_URL=http://127.0.0.1:8787

Production fix: enable CORSMiddleware on the real FastAPI (allow your web origin
or use allow_origin_regex for http://localhost:\\d+).
"""

from __future__ import annotations

import argparse
from http.client import HTTPConnection
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse

DEFAULT_UPSTREAM = "47.76.160.69"
DEFAULT_UPSTREAM_PORT = 80
DEFAULT_LISTEN = "127.0.0.1"
DEFAULT_PORT = 8787

SKIP_REQUEST_HEADERS = frozenset(
    {"host", "connection", "content-length", "transfer-encoding", "keep-alive"}
)
SKIP_RESPONSE_HEADERS = frozenset({"transfer-encoding", "connection"})


def build_handler(upstream_host: str, upstream_port: int):
    class Handler(BaseHTTPRequestHandler):
        protocol_version = "HTTP/1.1"

        def log_message(self, fmt: str, *args: object) -> None:
            print(f"[dev_api_proxy] {args[0]}")

        def _cors(self) -> None:
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header(
                "Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS"
            )
            self.send_header(
                "Access-Control-Allow-Headers",
                "Authorization, Accept, Content-Type",
            )
            self.send_header("Access-Control-Max-Age", "86400")

        def do_OPTIONS(self) -> None:
            self.send_response(204)
            self._cors()
            self.end_headers()

        def _forward_headers(self) -> dict[str, str]:
            out: dict[str, str] = {"Host": upstream_host}
            for key, val in self.headers.items():
                if key.lower() in SKIP_REQUEST_HEADERS:
                    continue
                out[key] = val
            return out

        def _proxy(self, method: str) -> None:
            parsed = urlparse(self.path)
            path_q = parsed.path or "/"
            if parsed.query:
                path_q = f"{path_q}?{parsed.query}"

            body: bytes | None = None
            if method in ("POST", "PUT", "PATCH"):
                raw = self.headers.get("Content-Length")
                n = int(raw) if raw and raw.isdigit() else 0
                body = self.rfile.read(n) if n > 0 else b""

            conn = HTTPConnection(upstream_host, upstream_port, timeout=60)
            try:
                conn.request(
                    method,
                    path_q,
                    body=body,
                    headers=self._forward_headers(),
                )
                upstream = conn.getresponse()
                payload = upstream.read()
                self.send_response(upstream.status)
                for hk, hv in upstream.getheaders():
                    if hk.lower() in SKIP_RESPONSE_HEADERS:
                        continue
                    self.send_header(hk, hv)
                self._cors()
                self.end_headers()
                if payload:
                    self.wfile.write(payload)
            finally:
                conn.close()

        def do_GET(self) -> None:
            self._proxy("GET")

        def do_POST(self) -> None:
            self._proxy("POST")

        def do_PUT(self) -> None:
            self._proxy("PUT")

        def do_PATCH(self) -> None:
            self._proxy("PATCH")

        def do_DELETE(self) -> None:
            self._proxy("DELETE")

    return Handler


def main() -> None:
    p = argparse.ArgumentParser(description="CORS dev proxy for Flutter Web")
    p.add_argument("--upstream", default=DEFAULT_UPSTREAM, help="API host")
    p.add_argument("--upstream-port", type=int, default=DEFAULT_UPSTREAM_PORT)
    p.add_argument("--listen", default=DEFAULT_LISTEN)
    p.add_argument("--port", type=int, default=DEFAULT_PORT)
    args = p.parse_args()

    handler = build_handler(args.upstream, args.upstream_port)
    httpd = ThreadingHTTPServer((args.listen, args.port), handler)
    print(
        f"dev_api_proxy: http://{args.listen}:{args.port} -> "
        f"http://{args.upstream}:{args.upstream_port}"
    )
    print(
        "Flutter Web: flutter run -d chrome "
        f"--dart-define=API_BASE_URL=http://{args.listen}:{args.port}"
    )
    httpd.serve_forever()


if __name__ == "__main__":
    main()
