import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 التطبيق يعمل على Render بنجاح!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))  # استخدام PORT من البيئة
    print(f"✅ يعمل التطبيق على المنفذ: {port}")  # طباعة المنفذ في اللوجات
    app.run(host="0.0.0.0", port=port, debug=True)
