//
//  Color.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

/// Цветовая схема элементов (их фона)
enum ElementsColorScheme {
    
    /// Используется для отображения негативного исхода финреза, падения стоимости актива в карточке
    static let destructive = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#F94241") : UIColor(hexString: "#F94241")
    }

    /// Новый цвет для графика с прогнозами аналитиков Refinitiv
    static let halfDestructive = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FC8B65") : UIColor(hexString: "#FC8B65")
    }

    /// Используется для отображения положительного исхода финреза, роста актива в карточке, потенциальной доходности
    static let constructive = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#1FBA66") : UIColor(hexString: "#1FBA66")
    }
    
    /// Новый цвет для графика с прогнозами аналитиков Refinitiv
    static let halfConstructive = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#9BDE66") : UIColor(hexString: "#9BDE66")
    }
    
    /// Используется для привлечения внимания пользователя, информирования об ошибках, показа алертов
    static let attention = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFA000") : UIColor(hexString: "#FFA000")
    }
}

/// Цветовая схема текста
enum TextColorScheme {
    
    /// Используется для заголовков, названий эмитентов в карточках
    static let foreground = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#28282D") : UIColor(hexString: "#FFFFFF")
    }

    /// Используется для второстепенного текста, подписей на карточках
    static let foreground2 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#818990") : UIColor(hexString: "#818990")
    }
    
    /// Используется для третьестепенного текста, потом напишу для какого, и для иконок в таббаре
    static let foreground3 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#C1CCD3") : UIColor(hexString: "#505258")
    }
    
    /// Используется для разделителей, переключателя штук в карточке инструмента, объектов на белом фоне
    static let foreground4 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#E0E9EC") : UIColor(hexString: "#3A3B41")
    }
    
    /// Для темной темы, потом опишем, но это будет текст
    static let foregroundSecondary = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#28282D")
    }
    
    /// Используется для размещения текста в виде лейбла или акцента
    static let other = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#5D3FAF") : UIColor(hexString: "#815DE3")
    }
    
    /// Используется для текста внутри disabled buttons. Показывает состояние неактивной кнопки.
    static let disabledButtonText = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#C1CCD3") : UIColor(hexString: "#3A3B41")
    }
}

/// Цветовая схема фона
enum BackgroundColorScheme {
    
    /// Основной фон мобильного приложения
    static let background = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#F0F4F7") : UIColor(hexString: "#000000")
    }

    /// Фон карточек, боттом шитов, второстепенных экранов
    static let background2 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#1B1B1D")
    }

    /// Фон элементов, отображаемых поверх основной иерархии элементов. Например, снекбаров
    static let background3 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#28282D")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let destructiveBackground = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFF0F0") : UIColor(hexString: "#331212")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let destructiveBackground2 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFE9E9") : UIColor(hexString: "#661B1B")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let constructiveBackground = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#E9FBEF") : UIColor(hexString: "#102E1E")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let constructiveBackground2 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#D2FAE1") : UIColor(hexString: "#0D42A")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let attentionBackground = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FEF6ED") : UIColor(hexString: "#332712")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let attentionBackground2 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFECCC") : UIColor(hexString: "#734800")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let otherBackground = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#F3F0FB") : UIColor(hexString: "#351F73")
    }
}

/// Цветовая схема приложения
enum ApplicationColorScheme {
    
    /// Используется для отображения акцентирования внимания пользователя на кнопке, уведомлении, выбранном разделе приложения, важной информации
    static let accent = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#3AB6EC") : UIColor(hexString: "#3AB6EC")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let accentBackground = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#F1FAFE") : UIColor(hexString: "#10252E")
    }
    
    /// Фон для размещения текста в виде лейбла и оформления карточек сторис
    static let accentBackground2 = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#D8F0FB") : UIColor(hexString: "#164559")
    }
    
    /// Фон для размещения текста в виде лейбла
    static let fixedWhite = UIColor { traitCollection -> UIColor in
        traitCollection.userInterfaceStyle == .light ? UIColor(hexString: "#FFFFFF") : UIColor(hexString: "#FFFFFF")
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
