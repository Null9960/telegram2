#!/bin/bash

echo "🚀 بدء تشغيل التطبيق..."

# التحقق مما إذا كان gunicorn مثبتًا
if command -v gunicorn &>/dev/null; then
    echo "✅ استخدام Gunicorn لتشغيل التطبيق..."
    exec gunicorn app:app --bind 0.0.0.0:${PORT:-10000}
else
    echo "⚠️ Gunicorn غير متاح، سيتم تشغيل التطبيق باستخدام Python مباشرة..."
    exec python app.py
fi
