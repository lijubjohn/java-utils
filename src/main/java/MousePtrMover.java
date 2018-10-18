import java.awt.*;

public class MousePtrMover {

    public static void main(String[] args) throws AWTException {
        Robot rb = new Robot();
        PointerInfo pointerInfo;
        while (true){
            rb.delay(1000*60);
            pointerInfo = MouseInfo.getPointerInfo();
            rb.mouseMove((int)pointerInfo.getLocation().getX()+1,(int)pointerInfo.getLocation().getY()+1);
        }
    }
}
