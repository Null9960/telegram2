import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "🚀 التطبيق يعمل بنجاح على البورت: " + str(os.environ.get("PORT", "غير معروف"))

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 0))
    app.run(host='0.0.0.0', port=port)
