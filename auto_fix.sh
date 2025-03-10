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

# 🔹 **محاولة العثور على بورت مفتوح تلقائيًا**
start_port=1024
end_port=65535
port_found=false

echo "🔍 البحث عن منفذ مفتوح بين $start_port و $end_port..."

for ((port=$start_port; port<=$end_port; port++)); do
    # محاولة معرفة إذا كان المنفذ مفتوحًا
    if command -v ss &>/dev/null; then
        if ! ss -tuln | grep -q ":$port "; then
            export PORT=$port
            port_found=true
            echo "✅ تم العثور على بورت متاح: $PORT"
            break
        fi
    elif command -v netstat &>/dev/null; then
        if ! netstat -tuln | grep -q ":$port "; then
            export PORT=$port
            port_found=true
            echo "✅ تم العثور على بورت متاح: $PORT"
            break
        fi
    else
        # إذا لم يكن ss أو netstat متاحًا، نستخدم طريقة بسيطة لتأكيد المنفذ
        echo "⚠️ لا يمكن العثور على ss أو netstat. التحقق من المنفذ بطريقة بديلة..."
        # افتراض أن المنفذ غير مشغول (للتجربة)
        export PORT=$port
        port_found=true
        break
    fi
done

if [ "$port_found" = false ]; then
    echo "❌ لم يتم العثور على بورت متاح في النطاق المحدد."
    exit 1
fi

# تحديث ملف البيئة
echo "PORT=$PORT" > .env
echo "✅ تم تحديث ملف .env بالمنفذ $PORT"

# 🔹 **تحديث Start Command**
echo "🔄 تحديث Start Command ..."
echo "#!/bin/bash" > start.sh
echo "exec gunicorn app:app --bind 0.0.0.0:\${PORT}" >> start.sh
chmod +x start.sh
echo "✅ تم تحديث Start Command"

# تشغيل التطبيق
echo "🚀 بدء التطبيق..."
./start.sh &
