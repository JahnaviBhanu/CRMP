function previewImage(event) {
    const file = event.target.files[0];
    if (!file) return;

    document.getElementById("profilePreview").src =
        URL.createObjectURL(file);
}

/* click image to preview full */
function openImagePreview(img) {
    const modal = document.getElementById("imgModal");
    const modalImg = document.getElementById("modalImg");

    modal.style.display = "flex";
    modalImg.src = img.src;
}

function closeImagePreview() {
    document.getElementById("imgModal").style.display = "none";
}
