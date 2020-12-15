FROM swift:5.3.1-focal as packages

ADD ./Package.* ./
RUN swift package resolve

FROM packages as debug-build
RUN mkdir -p Sources/LeafPressKit && touch Sources/LeafPressKit/empty.swift \
    && mkdir -p Sources/leaf-press && touch Sources/leaf-press/main.swift \
    && mkdir -p Tests/LeafPressKitUnitTests && touch Tests/LeafPressKitUnitTests/empty.swift \
    && mkdir -p Tests/LeafPressKitIntegrationTests && touch Tests/LeafPressKitIntegrationTests/empty.swift \
    && touch Tests/LinuxMain.swift
RUN swift build
ADD ./Sources ./Sources
ADD ./Tests ./Tests
RUN swift build

FROM debug-build as test
CMD swift test


FROM packages as release-build
ADD ./Sources ./Sources
RUN swift build -c release -Xswiftc -static-executable 
RUN mkdir /output
RUN cp $(swift build -c release -Xswiftc -static-executable --show-bin-path)/leaf-press /output/leaf-press


FROM node:14 as release
RUN apt-get update && apt-get -y install rsync 
COPY --from=release-build /output/leaf-press /leaf-press
ENTRYPOINT ["/leaf-press"]
CMD ["version"]