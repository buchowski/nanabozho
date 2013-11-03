function selectResult () {
	if ( $(this).parent().attr('id') == 'selected_users' ) {
		$("#users_to_add").children("#user_" + $(this).children("input").attr('id')).remove();
		$(this).remove();
		$("#searched_users").prepend($(this));
	} else {
		var user_id = $(this).children("input").attr('id');
		$(this).children("input").clone().appendTo($("#users_to_add"));
		$("#" + user_id).attr('id', 'user_' + user_id);
		$(this).remove();
		$("#selected_users").prepend($(this));
	}
}
function toggleHelp (e) {
	e.preventDefault();
	$("#help_text").slideToggle(600);
}
function changePage (e) {
	e.preventDefault();
	var page_num = $("#page_num").val();
	if ( $(e.target).attr('id') == 'next_page' ) {
		page_num++;
		if ( page_num == 2 ) { $("#prev_page").toggleClass('disabled') }
	} else {
		page_num--;
		if ( page_num == 1 ) { $("#prev_page").toggleClass('disabled') }
	} 
	$("#page_num").val(page_num);
	$("#search_form").trigger('submit');
}
function template (user) {
	return "<div class='search_result'><img class='search_img' src='" + user['profile_image_url'] + "'>"
			+ "<span class='username'>" + user['name'] + "</span><br><span class='location'>" + user['location'] + "</span>"
			+ "<input class='user_id' type='hidden' name='group[users][]' id='" + user['id_str'] + "'>";
}
function header_template (user) {
	return "<img src='" + user['profile_image_url'] + "'>"
			+ "<span>" + user['name'] + "</span><input class='user_id' type='hidden' " 
			+ "name='group[users][]' id='" + user['id_str'] + "'>";
}
function tweet_template (tweet, display_time) {
	return "<tr><td><p><span class='time'>" + display_time + "</span>" 
			+ "<span class='tweet_text'>" + tweet['text'] + "</span></td></tr>";
}
function show_template (user) {
	return "<div>" + header_template(user) + "</div><p id='" + user['twitter_id_str'] + "''></p>";
}
$(function () {
	$(".user_div").on('click', '.search_result', selectResult)
	$(".change_page").on('click', changePage);
	$("#help_link").on('click', toggleHelp);
	$("#search_form").on("submit", function (e) {
		e.preventDefault();

		var form = $(this);
		console.log(form.serialize());
		$.ajax({
			url: '/searches',
			type: 'POST',
			dataType: 'json',
			data: form.serialize(),
			success: function (response) {
				$("#searched_users").empty();
				$('#users').toggleClass('none', false);
				for ( var i = 0; i < response.length; i++) {
					$("#searched_users").append(template(response[i]));
					$("#" + response[i]['id_str']).val(JSON.stringify(response[i]));
				}
			},
			error: function (response) {
				console.log('ERROR: ' + response);
			}
		})
	})
})