<%-- 
    Document   : Map
    Created on : Mar 8, 2019, 3:32:21 PM
    Author     : giraf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix = "sql"%>
<link href="css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<!DOCTYPE html>
<html lang="en">
<%
    int i = 0;
    Date date = new Date();
    //[lat][lon]
    Double[][] coords = new Double[70][3];
%>
<!Style for google map>
<style>
    #map{
    width: 100%;
    height: 1000px;
    }
    .mapContainer{
        width:50%;
        position: relative;
    }
    .mapContainer a.direction-link {
        position: absolute;
        top: 15px;
        right: 15px;
        z-index: 100010;
        color: #FFF;
        text-decoration: none;
        font-size: 15px;
        font-weight: bold;
        line-height: 25px;
        padding: 8px 20px 8px 50px;
        background: #0094de;
        background-image: url('direction-icon.png');
        background-position: left center;
        background-repeat: no-repeat;
    }
    .mapContainer a.direction-link:hover {
        text-decoration: none;
        background: #0072ab;
        color: #FFF;
        background-image: url('direction-icon.png');
        background-position: left center;
        background-repeat: no-repeat;
    }
</style>
<!all the head does is instantiate the map and send it to the div>
<head>
    <script>
        var i = 0;
        var latlng = new Array([]);
    </script>
    <sql:setDataSource var = "snapshot" driver = "com.mysql.jdbc.Driver"
         url = "jdbc:mysql://localhost:3306/idlehotspots?zeroDateTimeBehavior=convertToNull"
         user = "root"  password = ""/>
    <sql:query dataSource = "${snapshot}" var = "result">
         SELECT * from sample_idling_test_data_2018;
        </sql:query>
    <sql:query dataSource = "${snapshot}" var = "count">
         SELECT COUNT(*) from sample_idling_test_data_2018;
        </sql:query>
    <c:forEach var = "row" items = "${result.rows}">
            <c:set var="lat" value="${row.Latitude}"/>
            <c:set var="lon" value="${row.Longitude}"/>
            <c:set var="lon" value="${row.Longitude}"/>
        <%
             coords[i][0] = Double.parseDouble(pageContext.getAttribute("lat").toString());
             coords[i][1] = Double.parseDouble(pageContext.getAttribute("lon").toString());
        %>
        <script>
            latlng[i] = [<%=coords[i][0]%>, <%=coords[i][1]%>];
            i++;
        </script>
        <%i++;%>
    </c:forEach>
    <!Might need somethign here>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA_-fzTBKX5ikxMsRH27L52hsc5Nj8lBL8"></script>
    <script>
    var myCenter = new google.maps.LatLng(40.4406, -79.9959);
    function initialize(){
        var mapProp = {
            center:myCenter,

            zoom:3,
            mapTypeId:google.maps.MapTypeId.HYBRID
        };

        var map = new google.maps.Map(document.getElementById("map"),mapProp);

        var rows = <%=coords.length%>;

        // markers
        //infowindows
        for(var i = 0; i < rows; i++){
            var pos = new google.maps.LatLng(latlng[i][0], latlng[i][1]);
            var content = i + "";
            addMarker(pos, content);
        } 


        var CentralPark = new google.maps.LatLng(37.7699298, -122.4469157);
        addMarker(CentralPark);

        addMarker(new google.maps.LatLng(40.4406, -79.9959));
        function addMarker(location, content) {
            var marker = new google.maps.Marker({
                position: location,
                map: map
            });
            var infoWindow = new google.maps.InfoWindow({
                content:content
            });
            marker.addListener('click', function() {
              infoWindow.open(map, marker);
            });
        }
    }

    google.maps.event.addDomListener(window, 'load', initialize);
    </script>
</head>
<!where the map is placed>
<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
        <a class="navbar-brand" href="#">Propel IT</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarsExampleDefault">
            <ul class="navbar-nav mr-auto">
                <li class="nav-item active">
                    <a class="nav-link" href="#">Home <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Map</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link disabled" href="#">Disabled</a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="dropdown01" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Dropdown</a>
                    <div class="dropdown-menu" aria-labelledby="dropdown01">
                        <a class="dropdown-item" href="#">Action</a>
                        <a class="dropdown-item" href="#">Another action</a>
                        <a class="dropdown-item" href="#">Something else here</a>
                    </div>
                </li>
            </ul>
            <form class="form-inline my-2 my-lg-0">
                <input class="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search">
                <button class="btn btn-secondary my-2 my-sm-0" type="submit">Search</button>
            </form>
        </div>
    </nav>
<div id="map">
    <div class="mapContainer">
    <a class="direction-link" target="_blank" href="//maps.google.com/maps?f=d&amp;daddr=37.422230,-122.084058&amp;hl=en"> Get Directions</a>
    <div id="map"></div>
</div>