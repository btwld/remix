import { tv } from 'tailwind-variants';

const comboBoxVariants = tv({
    defaultVariants: {
        fullWidth: false,
    },
    slots: {
        base: "combo-box",
        inputGroup: "combo-box__input-group",
        popover: "combo-box__popover",
        trigger: "combo-box__trigger",
        value: "combo-box__value",
    },
    variants: {
        fullWidth: {
            false: {},
            true: {
                base: "combo-box--full-width",
                inputGroup: "combo-box__input-group--full-width",
            },
        },
    },
});

export { comboBoxVariants };
