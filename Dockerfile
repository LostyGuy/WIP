FROM python:3.11

WORKDIR /Backend

COPY ./Backend/requirements.txt .
COPY ./Backend ./Backend

RUN pip install -r requirements.txt

CMD ["python", "./Backend/main.py"]

#!!!Remember to run game as well when it is ready!!!

# Get image on docker: docker pull lostyguy/wip
# Then get db: docker-compose up 
# /\
# ||
# For updates use this