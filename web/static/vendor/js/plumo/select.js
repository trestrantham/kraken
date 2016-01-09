$('.selectpicker').selectpicker({
    dropupAuto : false,
    style : "custom-select"
});

$('.selectpicker').selectpicker('setStyle', 'btn dropdown-toggle', 'remove');

$('.bootstrap-select').on('show.bs.dropdown', function () {
    var form_group = $(this).closest(".form-group"),
        form_group_height = form_group.height(),
        dropdown = $(this).find("div.dropdown-menu"),
        dropdown_height = dropdown.height();
        
    dropdown.css("top","-" + ( (dropdown_height / 2) - (form_group_height / 2) ) + "px");
});