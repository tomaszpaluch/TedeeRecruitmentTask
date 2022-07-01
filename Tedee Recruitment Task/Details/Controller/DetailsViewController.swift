import UIKit

class DetailsViewController: UIViewController {
    var coordinator: MainCoordinator?
    {
        get { logic.coordinator }
        set { logic.coordinator = newValue }
    }
    
    private let logic: DetailsLogic
    
    private let pinNameLabel: UILabel
    private let pinNameTextField: UITextField
    private let pinCodeLabel: UILabel
    private let pinCodeTextField: UITextField
    private let showCodeButton: UIButton
    
    private let generateCodeButton: UIButton
    private let deletePinButton: UIButton
    private let savePinButton: UIButton
    
    init(
        logic: DetailsLogic,
        savePinCompletion: @escaping (Pin) -> Void,
        deletePinCompletion: (() -> Void)?
    ) {
        self.logic = logic
        
        pinNameLabel = UILabel()
        pinNameTextField = UITextField()
        pinCodeLabel = UILabel()
        pinCodeTextField = UITextField()
        showCodeButton = UIButton()
        generateCodeButton = UIButton()
        deletePinButton = UIButton()
        savePinButton = UIButton()
        
        pinNameLabel.text = "PIN name:"
        pinNameTextField.text = logic.pin.name
        pinNameTextField.textAlignment = .right
        pinNameTextField.backgroundColor = .systemGray6
        pinCodeLabel.text = "PIN code:"
        pinCodeTextField.text = logic.pin.code
        pinCodeTextField.textAlignment = .right
        pinCodeTextField.backgroundColor = .systemGray6
        pinCodeTextField.isSecureTextEntry = true
        pinCodeTextField.isUserInteractionEnabled = false
        showCodeButton.setImage(
            UIImage(
                systemName: "eye"
            ),
            for: .normal
        )
        
        generateCodeButton.setTitle("Generate code", for: .normal)
        generateCodeButton.backgroundColor = .systemBlue
        generateCodeButton.titleLabel?.font = .systemFont(ofSize: 15)
        
        if let _ = deletePinCompletion {
            deletePinButton.setImage(
                UIImage(
                    systemName: "trash"
                ),
                for: .normal
            )
        } else {
            deletePinButton.setImage(
                UIImage(
                    systemName: "xmark"
                ),
                for: .normal
            )
        }
        deletePinButton.tintColor = .white
        deletePinButton.backgroundColor = .systemRed

        savePinButton.setTitle("Save PIN", for: .normal)
        savePinButton.backgroundColor = .systemGray
        savePinButton.titleLabel?.font = .systemFont(ofSize: 15)
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(pinNameLabel)
        view.addSubview(pinNameTextField)
        view.addSubview(pinCodeLabel)
        view.addSubview(pinCodeTextField)
        view.addSubview(showCodeButton)
        view.addSubview(generateCodeButton)
        view.addSubview(deletePinButton)
        view.addSubview(savePinButton)
        
        setupPinNameLabelConstraints()
        setupPinNameTextFieldConstraints()
        setupPinCodeLabelConstraints()
        setupPinCodeTextFieldConstraints()
        setupShowCodeButtonConstraints()
        setupGenerateCodeButtonConstraints()
        setupDeletePinButtonConstraints()
        setupSavePinButtonConstraints()
        
        pinNameTextField.addTarget(self, action: #selector(setName(_:)), for: .editingChanged)
        showCodeButton.addTarget(self, action: #selector(showCode), for: .touchUpInside)
        generateCodeButton.addTarget(self, action: #selector(generateCode), for: .touchUpInside)
        deletePinButton.addTarget(self, action: #selector(deletePin), for: .touchUpInside)
        savePinButton.addTarget(self, action: #selector(savePin), for: .touchUpInside)

        logic.savePinCompletion = savePinCompletion
        logic.deletePinCompletion = deletePinCompletion
        
        logic.setCode = { [weak self] code in
            self?.pinCodeTextField.text = code
        }
        
        logic.enableSaveButton = { [weak self] test in
            self?.savePinButton.isUserInteractionEnabled = test
            self?.savePinButton.backgroundColor = test ? .systemRed : .systemGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPinNameLabelConstraints() {
        pinNameLabel.translatesAutoresizingMaskIntoConstraints = false
        pinNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        pinNameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 18).isActive = true
    }
    
    private func setupPinNameTextFieldConstraints() {
        pinNameTextField.translatesAutoresizingMaskIntoConstraints = false
        pinNameTextField.topAnchor.constraint(equalTo: pinNameLabel.bottomAnchor, constant: 8).isActive = true
        pinNameTextField.leftAnchor.constraint(equalTo: pinNameLabel.leftAnchor, constant: 18).isActive = true
        pinNameTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -18).isActive = true
    }
    
    private func setupPinCodeLabelConstraints() {
        pinCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        pinCodeLabel.topAnchor.constraint(equalTo: pinNameTextField.bottomAnchor, constant: 18).isActive = true
        pinCodeLabel.leftAnchor.constraint(equalTo: pinNameLabel.leftAnchor).isActive = true
    }
    
    private func setupPinCodeTextFieldConstraints() {
        pinCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        pinCodeTextField.topAnchor.constraint(equalTo: pinCodeLabel.bottomAnchor, constant: 8).isActive = true
        pinCodeTextField.leftAnchor.constraint(equalTo: pinNameTextField.leftAnchor).isActive = true
        pinCodeTextField.rightAnchor.constraint(equalTo: pinNameTextField.rightAnchor).isActive = true
    }
    
    private func setupShowCodeButtonConstraints() {
        showCodeButton.translatesAutoresizingMaskIntoConstraints = false
        showCodeButton.leftAnchor.constraint(equalTo: pinCodeTextField.leftAnchor).isActive = true
        showCodeButton.heightAnchor.constraint(equalTo: pinCodeTextField.heightAnchor).isActive = true
        showCodeButton.centerYAnchor.constraint(equalTo: pinCodeTextField.centerYAnchor).isActive = true
    }
    
    private func setupGenerateCodeButtonConstraints() {
        generateCodeButton.translatesAutoresizingMaskIntoConstraints = false
        generateCodeButton.topAnchor.constraint(equalTo: pinCodeTextField.bottomAnchor, constant: 18).isActive = true
        generateCodeButton.leftAnchor.constraint(equalTo: pinNameLabel.leftAnchor).isActive = true
        generateCodeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        generateCodeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupDeletePinButtonConstraints() {
        deletePinButton.translatesAutoresizingMaskIntoConstraints = false
        deletePinButton.topAnchor.constraint(equalTo: generateCodeButton.topAnchor).isActive = true
        deletePinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deletePinButton.widthAnchor.constraint(equalTo: generateCodeButton.widthAnchor).isActive = true
        deletePinButton.heightAnchor.constraint(equalTo: generateCodeButton.heightAnchor).isActive = true
    }
    
    private func setupSavePinButtonConstraints() {
        savePinButton.translatesAutoresizingMaskIntoConstraints = false
        savePinButton.topAnchor.constraint(equalTo: generateCodeButton.topAnchor).isActive = true
        savePinButton.rightAnchor.constraint(equalTo: pinNameTextField.rightAnchor).isActive = true
        savePinButton.widthAnchor.constraint(equalTo: generateCodeButton.widthAnchor).isActive = true
        savePinButton.heightAnchor.constraint(equalTo: generateCodeButton.heightAnchor).isActive = true
    }
    
    @objc private func setName(_ sender: UITextField) {
        if let text = pinNameTextField.text {
            logic.setPinName(text)
        }
    }
    
    @objc private func showCode() {
        pinCodeTextField.isSecureTextEntry = !pinCodeTextField.isSecureTextEntry
    }
    
    @objc private func generateCode() {
        logic.generateCode()
    }
    
    @objc private func deletePin() {
        logic.deletePin()
    }
    
    @objc private func savePin() {
        logic.savePin()
        coordinator?.popViewController()
    }
}
