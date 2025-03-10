#!/bin/bash

echo "🚀 بدء عملية الإصلاح الذاتي..."

# التحقق من وجود Python
if ! command -v python3 &>/dev/null; then
    echo "⚠️ Python غير مثبت! جاري التثبيت..."
    apt-get update && apt-get install -y python3 python3-pip
fi

# التحقق من وجود pip
if ! command -v pip3 &>/dev/null; then
    echo "⚠️ pip غير مثبت! جاري التثبيت..."
    apt-get install -y python3-pip
fi

# تحديث pip وتثبيت المتطلبات
echo "🔄 تحديث pip وتثبيت المتطلبات..."
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

# التحقق من وجود gunicorn
if ! command -v gunicorn &>/dev/null; then
    echo "⚠️ gunicorn غير مثبت! جاري التثبيت..."
    python3 -m pip install gunicorn
fi

# التحقق من وجود Flask
if ! python3 -c "import flask" &>/dev/null; then
    echo "⚠️ Flask غير مثبت! جاري التثبيت..."
    python3 -m pip install flask
fi

# اكتشاف المنفذ المتاح وتحديث البيئة
export PORT=${PORT:-10000}
echo "🔄 استخدام المنفذ: $PORT"

# إنشاء ملف البيئة
echo "PORT=$PORT" > .env
echo "✅ تم تحديث ملف .env بالمنفذ $PORT"

# إنشاء start.sh لبدء التطبيق تلقائيًا
echo "🔄 تحديث Start Command ..."
echo "#!/bin/bash" > start.sh
echo "exec gunicorn app:app --bind 0.0.0.0:\${PORT:-10000}" >> start.sh
chmod +x start.sh
echo "✅ تم تحديث Start Command"

# تشغيل التطبيق
echo "🚀 بدء التطبيق..."
./start.sh &
