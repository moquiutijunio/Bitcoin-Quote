//
//  BlockchainChartView.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 06/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit
import Charts

final class BlockchainChartViewCell: UITableViewCell {
    static let reuseId = "BlockchainChartViewCell"
    
    @IBOutlet weak var chartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
    }
    
    private func applyLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        
        chartView.backgroundColor = .clear
        chartView.pinchZoomEnabled = true
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.chartDescription?.enabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.axisLineColor = .clear
        xAxis.valueFormatter = self
        xAxis.drawGridLinesEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.enabled = true
        leftAxis.gridColor = .gray
        leftAxis.labelTextColor = .gray
        leftAxis.axisLineColor = .clear
        leftAxis.drawGridLinesEnabled = true
//        leftAxis.axisMaximum = 100000000
//        leftAxis.axisMinimum = 0

        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false

        let l = chartView.legend
        l.enabled = false

        chartView.noDataText = NSLocalizedString("error.blockchain.chart", comment: "")
    }
    
    func bindIn(transactions: [Transaction]) {
        
        let dataEntry = transactions.map { (transaction) -> ChartDataEntry in
            let dataEntry = ChartDataEntry(x: transaction.miliseconds.toDouble, y: transaction.value)
            return dataEntry
        }

        let dataSet = LineChartDataSet(dataEntry)
        dataSet.lineWidth = 1
        dataSet.circleRadius = 0
        dataSet.colors = [.primaryColor]
        dataSet.highlightColor = .gray
        dataSet.drawValuesEnabled = false

        let data = LineChartData(dataSet: dataSet)
        chartView.data = data

        chartView.animate(xAxisDuration: 1)
    }
}

// MARK: - IAxisValueFormatter
extension BlockchainChartViewCell: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return Date(timeIntervalSince1970: value).stringWith(format: "MMM dd")
    }
}
