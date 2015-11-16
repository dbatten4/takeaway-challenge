module Message

   def send_message
    account_sid = ENV[:account_sid]
    auth_token = ENV[:auth_token]
    client = Twilio::REST::Client.new account_sid, auth_token
    client.messages.create(
      from: '441246488347',
      to: ENV[:phone_number],
      body: "Thank you. Your order has been placed successfully and will be \ 
        with before #{calculate_delivery_time}. \\
        The total cost is £#{total.round(2)}",
    )
  end

  private

  def calculate_delivery_time
    @time = Time.now
    @hour = @time.hour + 1
    @minute = @time.min
    @time_1hour = @hour.to_s + ":" + @minute.to_s
    @time_1hour
  end

end