//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Victor De la Torre Anicama on 13/10/21.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - outlets
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operationAdition: UIButton!
    @IBOutlet weak var operatorSustraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    // MARK: - variables
    
    private var total: Double = 0
    private var temp: Double = 0
    private var operating = false
    private var decimal = false
    private var operation: OperationType = .none
    
    // MARK: - constantes
    private let kDecimalSeparator = Locale.current.decimalSeparator
    private let kMaxLenght = 9
    private let kTotal = "total"
//    private let kMaxValue: Double = 999999999
//    private let kMinValue: Double = 0.00000001
    
    private enum OperationType {
        case none, addiction, sustraction, multiplication, division, percent
        }
    
    // Formato de valores auxiliares
    private let auxFormater: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formato de valores auxiliares totales
    private let auxTotalFormater: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formato de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formato de valores por pantalla en formato cientifico
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    // MARK: - initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        total = UserDefaults.standard.double(forKey: kTotal)
        
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorResult.round()
        operationAdition.round()
        operatorSustraction.round()
        operatorMultiplication.round()
        operatorDivision.round()
        
    }

    // MARK: - buttons actions
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        operating = true
        operation = .percent
        result()
        
        sender.shine()
    }
    @IBAction func operatorResultAction(_ sender: UIButton) {
        result()
        
        sender.shine()
    }
    @IBAction func operationAditionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .addiction
        sender.selectOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorSustractionCAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .sustraction
        sender.selectOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        
        operating = true
        operation = .division
        sender.selectOperation(true)
        
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormater.string(from: NSNumber(value: temp))!
        if !operating && currentTemp.count >= kMaxLenght {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator!
        decimal = true
        
        selecVisualOperation()
        
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)
        
        var currentTemp = auxTotalFormater.string(from: NSNumber(value: temp))!
        
        if !operating && currentTemp.count >= kMaxLenght {
            return
        }
        
        currentTemp = auxFormater.string(from: NSNumber(value: temp))!
        
        // seleccionando una operacion
        if operating {
            total = total == 0 ? temp : total
            resultLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        // seleccionando decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selecVisualOperation()
        
        sender.shine()
    }
    
    // Limpia los valores
    private func clear() {
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        if temp != 0 || total != 0 {
            temp = 0
            total = 0
            resultLabel.text = "\(temp)"
        } else {
            total = 0
        }
        result()
    }
    
    // Obtiene el resultado final
    private func result() {
        
        switch operation {
            
        case .none:
            break
        case .addiction:
            total = total + temp
            break
        case .sustraction:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
        }
        
        // Formateo en pantalla
        
        if let currentTotal = auxTotalFormater.string(from: NSNumber(value: total)), currentTotal.count > kMaxLenght {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        
        selecVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("TOTAL: \(total)")
    }
    
    private func selecVisualOperation() {
        
        if !operating {
            // No estamos operando
            operationAdition.selectOperation(false)
            operatorSustraction.selectOperation(false)
            operatorMultiplication.selectOperation(false)
            operatorDivision.selectOperation(false)
        } else {
            switch operation {
            case .none, .percent:
                operationAdition.selectOperation(false)
                operatorSustraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .addiction:
                operationAdition.selectOperation(true)
                operatorSustraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .sustraction:
                operationAdition.selectOperation(false)
                operatorSustraction.selectOperation(true)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .multiplication:
                operationAdition.selectOperation(false)
                operatorSustraction.selectOperation(false)
                operatorMultiplication.selectOperation(true)
                operatorDivision.selectOperation(false)
                break
            case .division:
                operationAdition.selectOperation(false)
                operatorSustraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(true)
                break
            }
        }
    }
}
