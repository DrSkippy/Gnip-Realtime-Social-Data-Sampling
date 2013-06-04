class figure_sig extends figure_un {

  float pre_dy;
  float sig_par = 0.8;

  figure_sig(String _name, int _n, float _dy) {
    super(_name, _n); 
    pre_dy = _dy;
  } 

  float sigmoid(float t, float dt, float dr) {
    // increases from 1 to 1 + dr
    return 1. + dr/(1. + exp(sig_par*(dt-t)));
  }

  void conf_curve(int x_origin, int x_pixels, int y_pixels) {
    float x;
    float y;
    float yu;
    float yl;
    // steps in increase
    float dt = 9;
    // signal increasees by...
    float dr = 1.5;
    //
    // settings
    strokeWeight(line_weight);
    float dx = x_pixels/(2.*dt);
    if (pre_dy == 0) {
      dy = y_pixels/poisson_ubounds(int(n*(1. + dr)));
    } else {
      dy = pre_dy;
    }
    // 
    // first point
    float x_last = 0;
    float rate = n;
    float y_last = rate * dy;
    float yu_last = poisson_ubounds(int(rate)) * dy;
    float yl_last = poisson_lbounds(int(rate)) * dy;
    // 
    //stroke(point_color);
    //point(x_origin + x_last, y_size - (x_origin + yu_last));
    //point(x_origin + x_last, y_size - (x_origin + yl_last));
    //point(x_origin + x_last, y_size - (x_origin + y_last));
    //
    for (int i=1;i<=2*dt;i++) {
      x = i * dx;
      rate = n * sigmoid(i, dt, dr);
      yu = poisson_ubounds(int(rate)) * dy;
      yl = poisson_lbounds(int(rate)) * dy;
      y = rate * dy;
      stroke(line_color);
      line(x_origin + x_last, y_size - (x_origin + yu_last), x_origin + x, y_size - (x_origin + yu));
      line(x_origin + x_last, y_size - (x_origin + yl_last), x_origin + x, y_size - (x_origin + yl));
      stroke(baseline_color);
      line(x_origin + x_last, y_size - (x_origin + y_last), x_origin + x, y_size - (x_origin + y));
      //stroke(point_color);
      //point(x_origin + x, y_size - (x_origin + yu));
      //point(x_origin + x, y_size - (x_origin + yl));
      //point(x_origin + x, y_size - (x_origin + y));
      x_last = x;
      yu_last = yu;
      yl_last = yl;
      y_last = y;
    }
    // The final value of the rate
    stroke(baseline_color);
    //line(x_origin, y_size - (x_origin + int(n*(1. + dr)*dy)), x_origin + dt*dx, y_size - (x_origin + int(n*(1. + dr)*dy)));
    arrow(x_origin + 50, int(x_origin + n*(1. + dr)*dy), int(x_origin + dt*dx/2), int(x_origin + n*(1. + dr)*dy));
    //
    // rate change = signal
    stroke(marker_color);
    int temp_x = int(x_origin + 3*dx);
    arrow(temp_x, int(x_origin + n*(1. + dr)*dy/2), temp_x, int(x_origin + n*(1. + dr)*dy));
    arrow(temp_x, int(x_origin + n*(1. + dr)*dy/2), temp_x, int(x_origin + n*dy));
    // CONFIDENCE
    // fig 3a
    int temp_n = 14;
    // s_arrow(int(temp_n*dx), int(poisson_ubounds(int(n * sigmoid(temp_n, dt, dr))) * dy), int(temp_n*dx - 40), int(poisson_ubounds(int(n * sigmoid(temp_n, dt, dr))) * dy - 88), 45);
    // fig 3b
    temp_n = 11;
    s_arrow(int(temp_n*dx), int(poisson_ubounds(int(n * sigmoid(temp_n, dt, dr))) * dy), int(temp_n*dx - 15), int(poisson_ubounds(int(n * sigmoid(temp_n, dt, dr))) * dy + 22), -25);
    temp_n = 16;
    // lower bound fig 3a, need this?
    // s_arrow(int(temp_n*dx), int(poisson_lbounds(int(n * sigmoid(temp_n, dt, dr))) * dy), int(temp_n*dx - 40), int(poisson_lbounds(int(n * sigmoid(temp_n, dt, dr))) * dy - 22), 35);
    // AVERAGE
    // fig 3a
    temp_n = 8;
    // s_arrow(int(temp_n*dx), int(n * sigmoid(temp_n, dt, dr) * dy), int(temp_n*dx  - 40), int(n * sigmoid(temp_n, dt, dr) * dy + 55), -45);
    // fig 3b
    temp_n = 6;
    s_arrow(int(temp_n*dx), int(n * sigmoid(temp_n, dt, dr) * dy), int(temp_n*dx  - 40), int(n * sigmoid(temp_n, dt, dr) * dy + 85), -45);
    //
    textAlign(CENTER, BOTTOM);
    text("Signal", 3*dx + x_origin, y_size - x_origin - int(n*(1. + dr)*dy) - 15);
    // fig 3a
    // text("Upper confidence boundary", 13.0*dx + x_origin, y_size - x_origin - 5);
    // fig 3b
    text("Upper confidence boundary", 13.0*dx + x_origin, y_size - x_origin - 105);
    // fig 3a
    //text("Average rate", 8*dx + x_origin, y_size - x_origin - 165);
    // fig 3a
    text("Average rate", 5*dx + x_origin, y_size - x_origin - 145);
  }
}

