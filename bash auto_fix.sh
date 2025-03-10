#!/bin/bash

echo "🚀 بدء تشغيل كود الإصلاح الذاتي لـ Render..."

### ✅ 1️⃣ التحقق من تثبيت Python
if ! command -v python3 &>/dev/null; then
    echo "⚠️  Python غير مثبت! جاري تثبيته..."
    apt-get update && apt-get install -y python3 python3-pip
else
    echo "✅ Python مثبت بالفعل!"
fi

### ✅ 2️⃣ إنشاء بيئة `venv` إذا لم تكن موجودة
if [ ! -d ".venv" ]; then
    echo "🔄 إنشاء بيئة `venv` جديدة..."
    python3 -m venv .venv
else
    echo "✅ بيئة `venv` موجودة بالفعل!"
fi

### ✅ 3️⃣ تفعيل البيئة الافتراضية
echo "🔄 تفعيل البيئة الافتراضية..."
source .venv/bin/activate

### ✅ 4️⃣ تحديث `pip` وتثبيت المتطلبات
echo "🔄 تحديث `pip` وتثبيت المتطلبات..."
python3 -m pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    python3 -m pip install -r requirements.txt
else
    echo "⚠️  ملف `requirements.txt` غير موجود! يرجى التأكد من إضافته."
    exit 1
fi

### ✅ 5️⃣ التأكد من تثبيت `gunicorn`
if ! command -v gunicorn &>/dev/null; then
    echo "⚠️  gunicorn غير مثبت! جاري تثبيته..."
    python3 -m pip install gunicorn
else
    echo "✅ gunicorn مثبت بالفعل!"
fi

### ✅ 6️⃣ التأكد من استخدام `gunicorn` من المسار الصحيح
GUNICORN_PATH=$(command -v gunicorn)
echo "🔄 ضبط مسار gunicorn إلى: $GUNICORN_PATH"

### ✅ 7️⃣ ضبط المنفذ ليكون ديناميكيًا
PORT=${PORT:-$(shuf -i 10000-65000 -n 1)}
echo "✅ سيتم تشغيل التطبيق على المنفذ: $PORT"

### ✅ 8️⃣ تشغيل التطبيق باستخدام `gunicorn`
echo "🚀 تشغيل التطبيق..."
exec $GUNICORN_PATH app:app --bind 0.0.0.0:$PORT
