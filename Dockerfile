FROM debian

RUN apt -y update && apt -y install dosbox xauth

RUN mkdir /app
WORKDIR /app

CMD /app/dosbox.sh

