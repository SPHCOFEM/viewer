function hp=vector(X,V)
plot([X(1),X(1)+V(1)],[X(2),X(2)+V(2)],'r-','LineWidth',2)
V1=[cos(30*pi/180),sin(30*pi/180);-sin(30*pi/180),cos(30*pi/180)]*V'/5;
V2=[cos(30*pi/180),-sin(30*pi/180);sin(30*pi/180),cos(30*pi/180)]*V'/5;
plot([X(1)+V(1),X(1)+V(1)-V1(1)],[X(2)+V(2),X(2)+V(2)-V1(2)],'r-','LineWidth',2)
plot([X(1)+V(1),X(1)+V(1)-V2(1)],[X(2)+V(2),X(2)+V(2)-V2(2)],'r-','LineWidth',2)
