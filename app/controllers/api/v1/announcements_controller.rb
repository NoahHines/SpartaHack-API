class Api::V1::AnnouncementsController < ApplicationController

  # GET /announcements
  def index
    render json: { announcements: [
      { id: 1, title: "SpartaHack", description:"Check out what we have planned for you at https://spartahack.com", pinned: 1, createdAt: "2016-09-29T02:58:43+00:00", updatedAt: "2016-09-29T05:48:43+00:00"},
      { id: 2, title: "About SpartaHack", description:"On the weekend of January 20th, we're bringing together 500 students of all skill levels and disciplines to get creative with tech, connect with peers and professionals, and forget the words \"I can't.\"", pinned: 0, createdAt: "2016-09-29T04:48:43+00:00", updatedAt: "2016-09-29T05:58:43+00:00"},
      { id: 3, title: "Go, go, go!", description:"It's 11:00pm! Let the hacking begin!", pinned: 0, createdAt: "2016-09-29T06:48:43+00:00", updatedAt: "2016-09-29T06:48:43+00:00"},
      { id: 4, title: "Announcement Title", description:"This is Noah's fake Announcement. He is picky and wanted more dummy Announcements.", pinned: 0, createdAt: "2016-09-29T06:48:43+00:00", updatedAt: "2016-09-29T06:48:43+00:00"},
      { id: 5, title: "Announcement Title", description:"This is a short Announcement.", pinned: 0, createdAt: "2016-09-29T06:48:43+00:00", updatedAt: "2016-09-29T06:48:43+00:00"}
    ] }, status: 200
  end

  # POST /applications
  def create


    if Rpush::Apns::App.find_by_name(announcement_params[:cert]).nil?
      unless File.exist?("config/#{announcement_params[:cert]}.pem")
        render json: { errors: { invalid: ["bogdan says oops"] } }, status: 422 and return
      end
      app = Rpush::Apns::App.new
      app.name = announcement_params[:cert]
      app.certificate = File.read("config/#{announcement_params[:cert]}.pem")
      app.environment = announcement_params[:env] # APNs environment.
      app.password = ""
      app.connections = 1
      app.save!
    end

    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(announcement_params[:cert])
    n.device_token = announcement_params[:token] # 64-character hex string
    n.alert = announcement_params[:text]
    n.data = { alert: announcement_params[:text] }
    n.save!

    Rpush.push

    render json: { push: ["Things went well, hopefully"]}, status: :created
  end

  # Only allow a trusted parameter "white list" through.
  def announcement_params
    params.permit(:token, :text, :cert, :env)
  end

end
