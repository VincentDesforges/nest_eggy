// progressbar.js@1.0.0 version is used
// Docs: http://progressbarjs.readthedocs.org/en/1.0.0/
import ProgressBar from 'progressbar.js'


var bar = new ProgressBar.Line(container, {
  strokeWidth: 4,
  easing: 'easeInOut',
  duration: 2000,
  color: '#636a75',
  trailColor: '#eee',

  easing: 'bounce',
  // strokeWidth: 1,

  trailWidth: 1,
  svgStyle: {width: '100%', height: '100%'},
  text: {
    style: {
      // Text color.
      // Default: same as stroke color (options.color)
      color: '#636a75;',
      position: 'absolute',
      right: '0',
      bottom: '0px',
      padding: 0,
      margin: 0,
      transform: null
    },
    autoStyleContainer: false
  },
  from: {color: '#636a75'},
  to: {color: '#6DB193'},
  step: (state, bar) => {
    bar.path.setAttribute('stroke', state.color);
    bar.setText(Math.round(bar.value() * 100) + ' %');
  }
});

var userGoal = document.getElementById('user-goal').dataset.goal

bar.animate(userGoal);  // Number from 0.0 to 1.0

