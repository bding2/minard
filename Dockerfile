FROM ghcr.io/scott-degraw/xsnoed:latest
USER root

RUN dnf install -y xorg-x11-server-Xvfb x11vnc novnc openbox && \
    dnf clean all

COPY entrypoint_xsnoed.sh /xsnoed/entrypoint_xsnoed.sh
RUN chmod +x /xsnoed/entrypoint_xsnoed.sh

ENTRYPOINT ["/xsnoed/entrypoint_xsnoed.sh"]
CMD ["nlag.sp.snolab.ca"]