#!/bin/bash

# Проверяем, суббота или воскресенье
if [ "$(date +%a)" = "Sat" ] || [ "$(date +%a)" = "Sun" ]; then
  # Проверяем, входит ли пользователь в группу admin
  if getent group admin | grep -qw "$PAM_USER"; then
    exit 0 # Разрешаем доступ
  else
    exit 1 # Запрещаем доступ
  fi
else
  exit 0 # Разрешаем доступ в будние дни
fi
