document.addEventListener("DOMContentLoaded", function() {
	const rows = document.querySelectorAll("table tbody tr");
	const rowsPerPage = 20;
	let currentPage = 1;

	function showPage(page) {
		const start = (page - 1) * rowsPerPage;
		const end = start + rowsPerPage;

		rows.forEach((row, index) => {
			if (index >= start && index < end) {
				row.style.display = "";
			} else {
				row.style.display = "none";
			}
		});

		// Update buttons
		document.getElementById("prev").disabled = page === 1;
		document.getElementById("next").disabled = end >= rows.length;
	}

	document.getElementById("prev").addEventListener("click", function() {
		if (currentPage > 1) {
			currentPage--;
			showPage(currentPage);
		}
	});

	document.getElementById("next").addEventListener("click", function() {
		if (currentPage * rowsPerPage < rows.length) {
			currentPage++;
			showPage(currentPage);
		}
	});

	// Show the first page initially
	showPage(currentPage);
});
