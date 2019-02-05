function [K,fx,fy,px,py,omega] = getIntrinsicParams()
  %% Refer calib_fisheye_zshade.txt
  fx= 658.77248;
  fy= 663.25464;
  px= 636.20736;
  py= 349.37424;
  omega=0.867213;
  slant = 0;
  tan_omega_half_2 = 2 * tan(omega/2);
  K = [ fx slant px; 0 fy py; 0 0 1 ];
end
