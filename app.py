import os
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "🚀 التطبيق يعمل بنجاح على Render!"

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 10000))  # السماح للبورتات الديناميكية
    app.run(host="0.0.0.0", port=port)
