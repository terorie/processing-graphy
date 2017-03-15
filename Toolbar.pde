import javax.swing.*;
import javax.swing.event.*;
import java.awt.*;
import java.awt.event.*;

public class Toolbar {
  
  public Toolbar(Settings settings) {
    JFrame frame = new JFrame("Controls");
    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    
    JPanel controlPanel  = new ToolPanel(settings);
    controlPanel.setOpaque(true);
    frame.setContentPane(controlPanel);
    
    frame.pack();
    frame.setVisible(true);
  }
  
}

public class ToolPanel extends JPanel {
  
  private final JSlider weightSlider;
  private final JSlider dijkstraDelay;
  private final JCheckBox bidirectional;
  private final Settings settings;
  private final JButton loadBtn, saveBtn;
  
  public ToolPanel(Settings _settings) {
    this.settings = _settings;
    
    weightSlider = new JSlider(1, 10);
    weightSlider.setOrientation(JSlider.HORIZONTAL);
    weightSlider.setMinorTickSpacing(1);
    weightSlider.setMajorTickSpacing(2);
    weightSlider.setValue(5);
    weightSlider.setPaintTicks(true);
    weightSlider.setPaintLabels(true);
    weightSlider.addChangeListener(new ChangeListener() {
      public void stateChanged(ChangeEvent e) {
        JSlider source = (JSlider) e.getSource();
        settings.connectionWeight = ((int)source.getValue());
      }
    });
    
    dijkstraDelay = new JSlider(0, 10);
    dijkstraDelay.setOrientation(JSlider.HORIZONTAL);
    dijkstraDelay.setMinorTickSpacing(1);
    dijkstraDelay.setMajorTickSpacing(2);
    dijkstraDelay.setValue(5);
    dijkstraDelay.setPaintTicks(true);
    dijkstraDelay.setPaintLabels(true);
    dijkstraDelay.addChangeListener(new ChangeListener() {
      public void stateChanged(ChangeEvent e) {
        settings.calculationDelay = ((int)dijkstraDelay.getValue());
      }
    });
    
    bidirectional = new JCheckBox();
    bidirectional.addChangeListener(new ChangeListener() {
      public void stateChanged(ChangeEvent e) {
        settings.bidirectionalConnection = bidirectional.isSelected();
      }
    });
    
    loadBtn = new JButton("Load");
    loadBtn.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        if(dik != null)
          dik.stop();
        dik = null;
        settings.isCalculating = true;
        loading = true;
        // Wait for current draw call to finish
        try {
          Thread.sleep(500);
        } catch(InterruptedException ignored) {}
        try { load(); }
        catch(Exception ex) { 
          System.out.println("Error loading JSON"); 
          ex.printStackTrace();
        } finally {
          settings.isCalculating = false;
          loading = false;
        }
      }
    });
    
    saveBtn = new JButton("Save");
    saveBtn.addActionListener(new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        if(dik != null)
          dik.stop();
        dik = null;
        settings.isCalculating = true;
        try { save(); }
        catch(IOException ex) { 
          System.out.println("Error saving JSON"); 
          ex.printStackTrace();
        } finally {
          settings.isCalculating = false;
        }
      }
    });
    
    setPreferredSize(new Dimension(786, 548));
    
    add(weightSlider);
    add(dijkstraDelay);
    add(bidirectional);
    add(loadBtn);
    add(saveBtn);
  }
  
}