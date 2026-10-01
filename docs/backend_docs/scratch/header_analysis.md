# Analysis of Header Differences

## TABLE 1: REVENUE & TAX

### Reference (Header_excel.xlsx) - Rows 7-8:
```
Row 7 (top header):
  B7: Invoice Date      (theme=6, font=Arial/12, merged with B8)
  C7: #                 (theme=6, font=Arial/12)
  D7: Detail/Description(theme=6, font=Arial/18, merged D7:E8) 
  E7: INVOICE VALUE     (theme=6, font=Arial/12)
  F7: INVOICE VALUE     (theme=6, font=Arial/12)
  G7: Currency          (theme=6, font=Arial Narrow/12, rot=90)
  H7: Currency\nExchange(theme=6, font=Arial Narrow/12, rot=90)
  I7: INVOICE Number    (theme=6, font=Arial/12)
  J7: Client            (theme=6, font=Arial/12)
  K7: Receive Date      (theme=6, font=Arial/12)
  L7: AMOUNT RECEIVED   (theme=6, font=Arial/12)
  M7: AMOUNT RECEIVED   (theme=6, font=Arial/12)
  N7: PPn               (FFFFFFCC yellow, font=Arial/12)
  O7: PPH\n(Pasal 23)   (FFFFFFCC yellow, font=Arial/12)
  P7: Biaya transfer    (theme=2/tint=-0.10, font=Arial/11)
  Q7: Remark            (theme=3/tint=0.80, font=Arial/11)

Row 8 (sub-header):
  B8: <MERGED with B7>
  C8: None              (theme=6)
  D8: None              (theme=6) 
  E8: USD               (theme=6, font=Arial/10)
  F8: IDR               (theme=6, font=Arial/10)
  G8: None              (theme=6)
  H8: None              (theme=6)
  I8: None              (theme=6)
  J8: None              (theme=6)
  K8: None              (theme=6)
  L8: USD               (theme=6, font=Arial/10)
  M8: IDR               (theme=6, font=Arial/10)
  N8: 0.11              (FFFFFFCC)
  O8: 0.02              (FFFFFFCC)
  P8: None              (theme=2)
  Q8: None              (theme=3)
```

### Template (Revenue-Cost_2024_cleaned_asli_cleaned.xlsx) - Rows 6-7:
```
Row 6 (top header - maps to output row 6):
  B6: Invoice Date      (theme=6)
  C6: #                 (theme=6)
  D6: Detail/Description(theme=6, merged D6:E7)
  F6: INVOICE VALUE     (theme=6)
  G6: Currency          (theme=6, rot=90)
  H6: Currency\nExchange(theme=6, rot=90)
  I6: INVOICE Number    (theme=6)
  J6: Client            (theme=6)
  K6: Receive Date      (theme=6)
  L6: AMOUNT RECEIVED   (theme=6)
  M6: PPn               (FFFFFFCC)
  N6: PPH\n(Pasal 23)   (FFFFFFCC)
  O6: Biaya transfer    (theme=2)
  P6: Remark            (theme=3)

Row 7 (sub-header - maps to output row 7):
  B7-E7: <MERGED>
  F7: None              (theme=6)
  G7-K7: <MERGED>
  L7: IDR               (theme=6)
  M7: 0.11              (FFFFFFCC)
  N7: 0.02              (FFFFFFCC)
  O7: <MERGED>
```

### DIFFERENCES (Template is MISSING):
1. Col E: "INVOICE VALUE" (USD sub) - template only has one INVOICE VALUE column (F)
2. Col M: "AMOUNT RECEIVED" second col - template only has L (single)
3. The reference has columns B-Q (16 cols), template has B-P (15 cols)
4. Reference uses E=USD, F=IDR sub-headers for INVOICE VALUE
5. Reference uses L=USD, M=IDR sub-headers for AMOUNT RECEIVED

### CONCLUSION:
The reference adds 1 extra column for "INVOICE VALUE" (split into USD/IDR)
and 1 extra column for "AMOUNT RECEIVED" (split into two).
Template has these as single columns, reference expands them to two each.

## What needs to happen:
Since the template is the base and we can't easily insert columns (would break all formulas),
we need to WRITE the reference headers directly onto the template after loading,
matching the column layout of the reference file exactly.
```
