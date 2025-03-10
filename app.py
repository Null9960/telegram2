import os
import socket
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 التطبيق يعمل بنجاح على Render!"

def find_available_port():
    """🔹 البحث عن منفذ مفتوح تلقائيًا وعدم فرض منفذ معين"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(("", 0))
        return s.getsockname()[1]

if __name__ == "__main__":
    port = int(os.environ.get("PORT", find_available_port()))  # 🔹 اختيار منفذ مفتوح تلقائيًا
    app.run(host="0.0.0.0", port=port)
