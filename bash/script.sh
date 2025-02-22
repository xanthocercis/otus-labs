#!/bin/bash

# Блокировка для предотвращения запуска нескольких копий скрипта
LOCKFILE=/tmp/web_log_analyzer.lock
if [ -e ${LOCKFILE} ] && kill -0 `cat ${LOCKFILE}`; then
    echo "Скрипт уже запущен"
    exit
fi

trap "rm -f ${LOCKFILE}; exit" INT TERM EXIT
echo $$ > ${LOCKFILE}

# Настройки
LOG_FILE="/var/log/nginx/access.log"  
REPORT_EMAIL="mail@mail.ru"  # указать нужный email
TMP_FILE="/tmp/web_log_analyzer.tmp"

# Временной диапазон
START_TIME=$(date -d '1 hour ago' +"%Y-%m-%d %H:%M:%S")
END_TIME=$(date +"%Y-%m-%d %H:%M:%S")

# Обработка логов
awk -v start="$START_TIME" -v end="$END_TIME" '{
    if ($4 > "["start && $4 < "["end) {
        print $1, $7, $9
    }
}' ${LOG_FILE} > ${TMP_FILE}

# Анализ данных
IP_LIST=$(awk '{print $1}' ${TMP_FILE} | sort | uniq -c | sort -nr | head -10)
URL_LIST=$(awk '{print $2}' ${TMP_FILE} | sort | uniq -c | sort -nr | head -10)
ERROR_LIST=$(awk '{if ($3 >= 400) print $3}' ${TMP_FILE} | sort | uniq -c | sort -nr)
HTTP_CODES=$(awk '{print $3}' ${TMP_FILE} | sort | uniq -c | sort -nr)

# Формирование письма
MAIL_CONTENT="Отчет за период с ${START_TIME} по ${END_TIME}

Топ IP адресов:
${IP_LIST}

Топ URL:
${URL_LIST}

Ошибки:
${ERROR_LIST}

Коды HTTP ответа:
${HTTP_CODES}"

# Отправка письма
echo -e "${MAIL_CONTENT}" | mail -s "Отчет о запросах к веб-серверу" ${REPORT_EMAIL}

# Очистка
rm -f ${TMP_FILE}
rm -f ${LOCKFILE}
