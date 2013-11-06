function addUser () {
	var user_id = $(this).children("input").attr('id');
	$(this).clone().prependTo($("#current_members"));
	$("#current_members").scrollTop = 0;
	$("#users_to_add").append(hidden_template({ twitter_id_str: user_id }));
	$(this).remove(); 
}
function removeUser () {
	$("#user_" + $(this).children("input").attr('id')).remove();
	$(this).remove();
}
// function toggleHelp (e) {
// 	e.preventDefault();
// 	$("#help_text").slideToggle(600);
// }
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
function hidden_template (user) {
	return "<input type='hidden' name='group[users][]' id='user_" + user['twitter_id_str'] + "'" 
				+ "value='" + user['twitter_id_str'] + "'></input>";
}
$(function () {
	$("#current_members").on("click", ".search_result", removeUser);
	$(".searched_users").on("click", ".search_result", addUser);
	$(".change_page").on('click', changePage);
	$("#search_form").on("submit", function (e) {
		e.preventDefault();
		var form = $(this);
		$.ajax({
			url: '/searches',
			type: 'POST',
			dataType: 'json',
			data: form.serialize(),
			success: function (response) {
				$("#searched_users_0").empty();
				$("#searched_users_1").empty();
				for ( var i = 0; i < response.length; i++) {
					$("#searched_users_" + (i % 2)).append(template(response[i]));
				}
			},
			error: function (response) {
				console.log('ERROR: ' + response);
			}
		})
	})
})