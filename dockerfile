FROM adoptopenjdk/openjdk16:alpine
RUN apk add git python3 py3-pip wget bash
RUN pip3 install requests
RUN mkdir minecraft
WORKDIR minecraft
RUN mkdir world; mkdir world_nether; mkdir world_the_end
RUN git clone https://github.com/brandon-gayne/mc-paper-pull-version-script.git
RUN wget $(python3 mc-paper-pull-version-script/build.py) 
RUN echo eula=true>eula.txt
ENTRYPOINT java -Xms2G -Xmx2G -jar paper-*.jar --nogui