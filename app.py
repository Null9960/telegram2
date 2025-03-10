import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 التطبيق يعمل على Render بنجاح!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))  # تحديد المنفذ الصحيح
    app.run(host="0.0.0.0", port=port)
