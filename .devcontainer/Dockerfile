# 使用Python latest官方镜像
FROM python:latest

# 设置工作目录
WORKDIR /ml

# 安装Python包
RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup && 
    sudo sed -i '/^deb .*main/ s/$/ contrib non-free/' /etc/apt/sources.list &&
    pip install --no-cache-dir requests numpy pandas torch scikit-learn tensorflow tsai seaborn notebook sqlalchemy statsmodels dtaidistance
