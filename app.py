import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "🚀 التطبيق يعمل بنجاح على Render!"

@app.route('/healthz')
def health_check():
    return "OK", 200  # Health Check لمنع Render من فشل التشغيل

if __name__ == "__main__":
    import os
    port = int(os.environ.get("PORT", 1024))  # استخدام البورت المخصص من البيئة
    app.run(host="0.0.0.0", port=port)
