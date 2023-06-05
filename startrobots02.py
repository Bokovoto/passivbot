import subprocess
import time

def start_robots():
    robots = [
        "python3.8 passivbot.py binance_02 UNIUSDT passivbot_optimizations/configs/v5.9.5/recursive/may_2023/au_disabled/recursive_longonly_04_may_29_23/UNIUSDT_20230529165735_432a7/config.json",
        "python3.8 passivbot.py binance_02 GALUSDT passivbot_optimizations/configs/v5.9.5/recursive/march_2023/recursive_longonly_03_26_23/GALUSDT_20230327051838_b74b7/config.json",
        "python3.8 passivbot.py binance_02 THETAUSDT passivbot_optimizations/configs/v5.9.5/recursive/may_2023/au_disabled/recursive_longonly_04_may_29_23/THETAUSDT_20230529165735_432a7/config.json",
        "python3.8 passivbot.py binance_02 HBARUSDT passivbot_optimizations/configs/v5.9.5/recursive/march_2023/recursive_longonly_03_26_23/HBARUSDT_20230327051838_b74b7/config.json",
        "python3.8 passivbot.py binance_02 MATICUSDT passivbot_optimizations/configs/v5.9.5/recursive/march_2023/recursive_longonly_03_26_23/MATICUSDT_20230327051838_b74b7/config.json",
        "python3.8 passivbot.py binance_02 SNXUSDT passivbot_optimizations/configs/v5.9.5/recursive/march_2023/recursive_longonly_03_26_23/SNXUSDT_20230327051838_b74b7/config.json",
        "python3.8 passivbot.py binance_02 AUDIOUSDT passivbot_optimizations/configs/v5.9.5/recursive/may_2023/au_disabled/recursive_longonly_04_may_29_23/AUDIOUSDT_20230529165735_432a7/config.json",
        "python3.8 passivbot.py binance_02 GRTUSDT passivbot_optimizations/configs/v5.9.5/recursive/may_2023/au_disabled/recursive_longonly_04_may_29_23/GRTUSDT_20230529165735_432a7/config.json",
        "python3.8 passivbot.py binance_02 OMGUSDT passivbot_optimizations/configs/v5.9.5/recursive/may_2023/au_disabled/recursive_longonly_04_may_29_23/OMGUSDT_20230529165735_432a7/config.json",
        "python3.8 passivbot.py binance_02 ZILUSDT passivbot_optimizations/configs/v5.9.5/recursive/may_2023/au_disabled/recursive_longonly_04_may_29_23/ZILUSDT_20230529165735_432a7/config.json",
        "python3.8 passivbot.py binance_02 FTMUSDT passivbot_optimizations/configs/v5.9.5/recursive/may_2023/au_disabled/recursive_longonly_04_may_29_23/FTMUSDT_20230529165735_432a7/config.json"
    ]

    for robot_command in robots:
        subprocess.Popen(['xterm', '-e', robot_command])

        time.sleep(1)  # Пауза от 1 секунда между стартирането на прозорците

start_robots()
