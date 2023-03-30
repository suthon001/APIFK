page 60050 "Export Template API"
{
    ApplicationArea = All;
    Caption = 'Export Template API';
    PageType = ListPlus;
    UsageCategory = Lists;
    actions
    {
        area(Processing)
        {
            action(ExportAPI)
            {
                Caption = 'ExportCustomer';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = basic;
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                begin
                    FKFunc.ExportJsonFormat(PAGE::"Customer Card", Database::Customer, 'customerlists');
                end;
            }
            action(ExportPO)
            {
                Caption = 'ExportPO';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = basic;
                trigger OnAction()
                var
                    FKFunc: Codeunit "FK Func";
                    DocType: Enum "Purchase Document Type";
                begin
                    FKFunc.ExportJsonFormatPurchase(PAGE::"Purchase Order", PAGE::"Purchase Order Subform", DocType::Order, 'purchaseorders');
                end;
            }
        }
    }
}
