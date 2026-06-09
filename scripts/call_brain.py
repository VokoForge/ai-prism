"""scripts/call_brain.py — 调用 Brain 2 生成草稿（脱敏版示例）"""
import os
import sys
import json
import urllib.request

def call_brain(prompt: str, brain: str) -> str:
    api_key = os.environ.get("BRAIN_API_KEY")
    if not api_key:
        return prompt  # 本地无 key 时直接返回模板

    # 实际生产中替换为真实 LLM gateway
    # 这里只给出一个脱敏的接口形状
    payload = {
        "model": brain,
        "messages": [
            {"role": "system", "content": "You are Rex, a writing agent. Output bilingual EN/ZH mirror."},
            {"role": "user", "content": prompt}
        ],
    }
    req = urllib.request.Request(
        "https://brain.example.com/v1/chat",
        data=json.dumps(payload).encode(),
        headers={"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req) as resp:
        return json.loads(resp.read())["choices"][0]["message"]["content"]


if __name__ == "__main__":
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--prompt", required=True)
    ap.add_argument("--brain", default="brain-2")
    ap.add_argument("--output", required=True)
    args = ap.parse_args()

    result = call_brain(args.prompt, args.brain)
    with open(args.output, "w") as f:
        f.write(result)
    print(f"[brain] wrote {args.output}")
