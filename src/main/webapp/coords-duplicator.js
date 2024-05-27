const x0Input = document.getElementById('x0');
const y0Input = document.getElementById('y0');
const x1Input = document.getElementById('x1');
const y1Input = document.getElementById('y1');

x1Input.addEventListener('input', function() {
	x0Input.value = x1Input.value;
});

y1Input.addEventListener('input', function() {
	y0Input.value = y1Input.value;
});
