import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "🚀 التطبيق يعمل بنجاح على Render!"

if __name__ == '__main__':
    port = int(os.getenv("PORT", 10000))  # المنفذ الرئيسي
    alt_port = int(os.getenv("ALT_PORT", 8080))  # المنفذ البديل الأول
    fallback_port = int(os.getenv("FALLBACK_PORT", 5000))  # المنفذ الاحتياطي
    
    # تجربة المنافذ بالترتيب
    try:
        app.run(host='0.0.0.0', port=port)
    except:
        print(f"⚠️ فشل التشغيل على {port}، التجربة على {alt_port}...")
        try:
            app.run(host='0.0.0.0', port=alt_port)
        except:
            print(f"⚠️ فشل التشغيل على {alt_port}، التجربة على {fallback_port}...")
            app.run(host='0.0.0.0', port=fallback_port)  # المحاولة الأخيرة
