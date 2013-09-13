function selectResult () {
	console.log($(this).parent().attr('id'));
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
function template (user) {
	return "<div class='search_result'><img class='search_img' src='" + user['profile_image_url'] + "'>"
			+ "<span class='username'>" + user['name'] + "</span><br><span class='location'>" + user['location'] + "</span>"
			+ "<input class='user_id' type='hidden' name='group[users][]' id='" + user['id_str'] + "'></div>";
}
function header_template (user) {
	return "<img src='" + user['profile_image_url'] + "'>"
			+ "<span>" + user['name'] + "</span><input class='user_id' type='hidden' " 
			+ "name='group[users][]' id='" + user['id_str'] + "'>";
}
function tweet_template (tweet) {
	return "<p><span>" + tweet['text'] + "</span><span>" + tweet['created_at'] + "</span></p>";
}
function show_template (user) {
	return "<div>" + header_template(user) + "</div><p id='" + user['twitter_id_str'] + "''></p>";
}
$(function () {
	$("#selected_users").on('click', '.search_result', selectResult)
	$("#searched_users").on('click', '.search_result', selectResult)
	$("#search_form").on("submit", function (e) {
		e.preventDefault();

		var form = $(this);
		$.ajax({
			url: '/searches',
			type: 'POST',
			dataType: 'json',
			data: form.serialize(),
			success: function (response) {
				$("#searched_users").empty();
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