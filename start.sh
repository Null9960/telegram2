#!/bin/bash
echo "🚀 تشغيل التطبيق باستخدام Gunicorn..."
exec gunicorn app:app --bind 0.0.0.0:${PORT:-10000}
