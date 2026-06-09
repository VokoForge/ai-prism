"""scripts/pull_feishu_material.py — 拉取飞书 Wiki 素材（脱敏版示例）"""
import os
import json
import sys

def pull(scope: str, output: str) -> None:
    token = os.environ.get("LARK_CLI_TOKEN")
    if not token:
        # 本地无 token 时写入空文件，便于测试
        with open(output, "w") as f:
            f.write("")
        return

    # 实际生产中调用 lark-cli 拉取
    # 这里只给一个脱敏的接口形状
    import subprocess
    subprocess.run([
        "lark-cli", "wiki", "nodes", "list",
        "--scope", scope,
        "--as", "bot",
        "--format", "json"
    ], check=True, stdout=open(output, "w"))


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--scope", required=True)
    ap.add_argument("--output", required=True)
    args = ap.parse_args()
    pull(args.scope, args.output)
    print(f"[feishu] wrote {args.output}")
