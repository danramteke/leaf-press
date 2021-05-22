FROM swift:5.4-focal as packages
# ADD ./Sources ./Sources
# ADD ./Tests ./Tests
# ADD ./Package.swift ./Package.swift
# ADD ./Package.resolved ./Package.resolved
ADD ./ ./

FROM packages as debug-build
RUN swift build

FROM packages as test
CMD swift test

FROM packages as release-build
RUN swift build -c release -Xswiftc -static-executable 
RUN mkdir /output
RUN cp $(swift build -c release -Xswiftc -static-executable --show-bin-path)/leaf-press /output/leaf-press
RUN cp -r $(swift build -c release -Xswiftc -static-executable --show-bin-path)/leaf-press_LeafPressKit.resources /output/leaf-press_LeafPressKit.resources


FROM node:14 as release
COPY --from=release-build /output/leaf-press /usr/local/bin/leaf-press
COPY --from=release-build /output/leaf-press_LeafPressKit.resources /usr/local/bin/leaf-press_LeafPressKit.resources 
CMD ["leaf-press", "--help"]