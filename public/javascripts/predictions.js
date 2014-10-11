$(document).ready(function () {
    $('.predictions-form').submit(function (event) {
        event.preventDefault();

        var predictions = [];

        $('.prediction').each(function () {
            var prediction = {};
            prediction.home_team = $(this).data('home-team');
            prediction.away_team = $(this).data('away-team');
            prediction.kick_off = $(this).data('kick-off');
            prediction.home_team_score = parseInt($(this).find('.home-score option:selected').text());
            prediction.away_team_score = parseInt($(this).find('.away-score option:selected').text());
            prediction.goal_scorer = $(this).find('.goal-scorer option:selected').text();
            prediction.additional_goal_scorer = $(this).find('.additional-goal-scorer option:selected').text();

            predictions.push(prediction);

        });

        predictions_json = JSON.stringify(predictions);

        $.ajax({
            type: 'post',
            dataType: 'json',
            url: '/predictions',
            data: predictions_json,
            success: function (data) {
                if (data.success) {
                    $('.alert-success').removeClass('hidden');
                }
            },
            error: function (data) {
//                          display success message look at bootstrap
            },
            complete: function () {

            }
        });
    });

    $('#close-success').click(function (event) {
        $('.alert-success').addClass('hidden');
    });
});