function fixQuotesAndExtraSpaces(s) {
    const quoteRE = /[”“]/
    const globalQuoteRE = / *([”“]) */g
    if (/"/.test(s)) {
        // fix quotes into smartQuotes
        if (quoteRE.test(s)) {
            panic('mixed pretty quotes and regular quotes not allowed')
        }
        let count = 0
        s = s.replace(/ *" */g, () => {
            const key = isEven(count++) ? 1 : 2
            return prettyQuote(key)
        })
    } else {
        s = s.replace(globalQuoteRE, '$1')
        // removes the spaces around it.
    }
    const r = / *([：。！，？])(\s*)/gm
    s = s.replace(r, (_, punc, afterSpaces, offset, original) => {
        const next = original[offset + 1]
        if (/\n/.test(afterSpaces)) {
            afterSpaces = afterSpaces.replace(/ /g, '')
        } else if (next && quoteRE.test(next)) {
            afterSpaces = ''
        } else {
            afterSpaces = ' '
        }
        return punc + afterSpaces
    })
    return s
}

function tokenize(s) {
    const tokens = getLineTokens(s)
    for (let i = 0; i < tokens.length; i++) {
        const token = tokens[i]
        if (/^--/.test(token.text)) {
            tokens[i - 1].spacingAfter = 0
            tokens[i + 1].spacingBefore = 0
            token.newlines = 0
            token.linebreak = true
        }
    }
    return tokens
}

function main(s) {
    const text = fixQuotesAndExtraSpaces(s)
    const sentenceTokens = tokenize(text)
    return sentenceTokens
}

