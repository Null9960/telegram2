import os

# 🔹 تحديد إطار العمل (Flask أو FastAPI) تلقائيًا
USE_FLASK = os.getenv("USE_FLASK", "true").lower() == "true"

if USE_FLASK:
    # ✅ تشغيل تطبيق Flask
    from flask import Flask

    app = Flask(__name__)

    @app.route("/")
    def home():
        return "✅ Flask is running on Render!"

    if __name__ == "__main__":
        port = int(os.environ.get("PORT", 10000))  # استخدام المنفذ الصحيح من Render
        app.run(host="0.0.0.0", port=port)

else:
    # ✅ تشغيل تطبيق FastAPI
    import uvicorn
    from fastapi import FastAPI

    app = FastAPI()

    @app.get("/")
    def read_root():
        return {"message": "✅ FastAPI is running on Render!"}

    if __name__ == "__main__":
        port = int(os.environ.get("PORT", 10000))
        uvicorn.run(app, host="0.0.0.0", port=port)
