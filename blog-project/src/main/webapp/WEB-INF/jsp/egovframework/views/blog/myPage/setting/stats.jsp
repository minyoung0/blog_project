<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.time.LocalDate"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>방문자 통계</title>
    
    <!-- ✅ Bootstrap & Chart.js -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js"></script>

    <style>
        .card {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        #visitChart {
            max-height: 400px;
        }

        .form-control:disabled {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body class="bg-light">

<%
    String today = LocalDate.now().toString();
%>

<div class="container mt-5">
    <div class="card p-4">
        <h4 class="mb-4 text-center">📊 방문자 통계</h4>

        <!-- ✅ 날짜 선택 -->
        <div class="row mb-4 justify-content-center">
            <div class="col-md-4">
                <label for="startDate" class="form-label">시작 날짜</label>
                <input type="date" class="form-control" id="startDate" max="<%=today%>">
            </div>
            <div class="col-md-4">
                <label for="endDate" class="form-label">종료 날짜</label>
                <input type="date" class="form-control" id="endDate" max="<%=today%>" disabled>
            </div>
        </div>

        <!-- ✅ 그래프 -->
        <div class="mt-4">
            <canvas id="visitChart"></canvas>
        </div>
    </div>
</div>

<script>
    document.getElementById('startDate').addEventListener('change', function () {
        let startDateValue = this.value;
        let endDateInput = document.getElementById('endDate');

        if (startDateValue) {
            endDateInput.min = startDateValue;
            endDateInput.disabled = false;
        } else {
            endDateInput.value = '';
            endDateInput.disabled = true;
        }
    });

    document.getElementById('startDate').addEventListener('change', fetchVisitStats);
    document.getElementById('endDate').addEventListener('change', fetchVisitStats);

    function fetchVisitStats() {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        if (!startDate || !endDate) return;

        $.ajax({
            url: '/blog/visitStats.do',
            type: 'GET',
            data: {startDate, endDate},
            success: function (response) {
                if (response.visitStats) {
                    renderVisitChart(response.visitStats);
                } else {
                    console.error("데이터 없음");
                }
            },
            error: function (error) {
                console.error("에러 발생:", error);
            }
        });
    }

    $(document).ready(function () {
        $.ajax({
            url: '/blog/visitStatsNormal.do',
            type: 'GET',
            success: function (response) {
                if (response.visitStats) {
                    renderVisitChart(response.visitStats);
                } else {
                    console.error("데이터 없음");
                }
            },
            error: function (error) {
                console.error("에러 발생:", error);
            }
        });
    });

    function renderVisitChart(visitStats) {
        let labels = [];
        let data = [];

        visitStats.forEach(function (stat) {
            labels.push(stat.visitDate);
            data.push(stat.visitCount);
        });

        let ctx = document.getElementById('visitChart').getContext('2d');

        if (window.visitChartInstance) {
            window.visitChartInstance.destroy();
        }

        window.visitChartInstance = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '방문자 수',
                    data: data,
                    borderColor: 'rgba(75, 192, 192, 1)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderWidth: 2,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                scales: {
                    x: {
                        title: {
                            display: true,
                            text: '날짜'
                        }
                    },
                    y: {
                        title: {
                            display: true,
                            text: '방문자 수'
                        },
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return Number.isInteger(value) ? value : null;
                            },
                            stepSize: 1
                        }
                    }
                }
            }
        });
    }
</script>

</body>
</html>
