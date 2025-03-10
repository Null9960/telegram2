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

# إنشاء بيئة افتراضية إذا لم تكن موجودة
if [ ! -d "venv" ]; then
    echo "🔄 إنشاء بيئة افتراضية..."
    python3 -m venv venv
fi

# تفعيل البيئة الافتراضية
source venv/bin/activate
echo "✅ تم تفعيل البيئة الافتراضية"

# تحديث pip وتثبيت المتطلبات
echo "🔄 تحديث pip وتثبيت المتطلبات..."
pip install --upgrade pip
pip install -r requirements.txt

# التحقق من وجود gunicorn
if ! command -v gunicorn &>/dev/null; then
    echo "⚠️ gunicorn غير مثبت! جاري التثبيت..."
    pip install gunicorn
fi

# التحقق من وجود Flask
if ! python3 -c "import flask" &>/dev/null; then
    echo "⚠️ Flask غير مثبت! جاري التثبيت..."
    pip install flask
fi

# البحث عن منفذ مفتوح بين 1024 و 65535
echo "🔍 البحث عن منفذ مفتوح..."
port=1024
while [ $port -lt 65535 ]; do
    if ! (netstat -tuln 2>/dev/null | grep -q ":$port "); then
        export PORT=$port
        echo "✅ تم العثور على منفذ متاح: $PORT"
        break
    fi
    ((port++))
done

# تحديث ملف البيئة
echo "PORT=$PORT" > .env
echo "✅ تم تحديث ملف .env بالمنفذ $PORT"

# تحديث Start Command تلقائيًا
echo "🔄 تحديث Start Command ..."
echo "#!/bin/bash" > start.sh
echo "exec gunicorn app:app --bind 0.0.0.0:\${PORT}" >> start.sh
chmod +x start.sh
echo "✅ تم تحديث Start Command"

# تشغيل التطبيق مع التأكد من الاستماع للمنفذ
echo "🚀 بدء التطبيق..."
./start.sh &
