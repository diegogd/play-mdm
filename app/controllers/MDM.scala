package controllers

import java.io.File

import play.api._
import play.api.mvc._

object MDM extends Controller {

  def index = Action {
    Ok(views.html.index_mdm())
  }

  def CA = Action {
    val certFile = new File("certificates/myca.crt")
    
    if (certFile.exists())
      Ok(scala.io.Source.fromFile(certFile.getCanonicalPath).mkString).as("application/x-x509-ca-cert")
    else
      NotFound
  }

  def enroll = Action {
    NotImplemented
  }

  def profile = Action {
    NotImplemented
  }

}
