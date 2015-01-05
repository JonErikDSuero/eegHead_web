function insert_waves() {
  params = {
    timestamp: new Date().toString(),
    wave_csv: create_random_numbers(12).join(),
  }

  $.post( "/v1/waves/insert", params, function(data) {
  });

  setTimeout(insert_waves, 1000);
}

function create_random_numbers(n) {
  numbers = []
  random_number = Math.floor(Math.random() * 11);
  for (var i=0; i<n; i++){
    numbers[i] = random_number;
  }
  return numbers
}

insert_waves();
